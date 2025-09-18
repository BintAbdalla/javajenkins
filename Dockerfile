# =========================
# Étape 1 : Build de l'application
# =========================
FROM maven:3.9.3-eclipse-temurin-17 AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de configuration Maven
COPY pom.xml ./
# Télécharger les dépendances Maven (cache optimisé)
RUN mvn dependency:go-offline

# Copier le reste du projet
COPY src ./src

# Construire l'application (générer le jar)
RUN mvn clean package -DskipTests

# =========================
# Étape 2 : Image pour exécuter l'application
# =========================
FROM eclipse-temurin:17-jdk-alpine

# Définir le répertoire de l'application
WORKDIR /app

# Copier le JAR construit depuis l'étape builder
COPY --from=builder /app/target/*.jar app.jar

# Exposer le port de l'application (ex. Spring Boot 8080)
EXPOSE 8080

# Lancer l'application Java
ENTRYPOINT ["java", "-jar", "app.jar"]
