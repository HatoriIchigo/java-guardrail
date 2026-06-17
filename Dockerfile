# syntax=docker/dockerfile:1

# ---- Stage 1: Build ----
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# 社内SSL傍受(Zscaler)対応: ルートCAをJVMトラストストアに取り込む
COPY zscaler.crt /tmp/zscaler.crt
RUN keytool -importcert -noprompt -trustcacerts \
        -alias zscaler-root \
        -file /tmp/zscaler.crt \
        -keystore "$JAVA_HOME/lib/security/cacerts" \
        -storepass changeit

# 依存だけ先に解決してレイヤーキャッシュを効かせる
COPY pom.xml .
RUN mvn -B dependency:go-offline

# ソースをコピーしてビルド
COPY src ./src
RUN mvn -B clean package -DskipTests

# ---- Stage 2: Runtime ----
FROM eclipse-temurin:21-jre AS runtime
WORKDIR /app

# 非rootユーザーで実行
RUN useradd --system --no-create-home appuser

# ビルド成果物のみ持ち込む（shade 同梱の app.jar。original-app.jar 等のバックアップは除外）
COPY --from=build /app/target/app.jar app.jar

USER appuser
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
