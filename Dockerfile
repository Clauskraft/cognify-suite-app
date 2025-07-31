# Stage 1: Production Environment
# Vi bruger et slankt og hærdet Nginx-image til at servere det statiske indhold.
# Dette sikrer en lille container-størrelse og høj sikkerhed.
FROM nginx:1.25-alpine

# Cloud Run forventer, at services lytter på port 8080.
# Vi opretter en brugerdefineret Nginx-konfiguration for at håndtere dette.
# Denne konfiguration instruerer Nginx i at lytte på port 8080 og servere index.html for alle anmodninger.
RUN echo "server { listen 8080; location / { root /usr/share/nginx/html; try_files \$uri /index.html; } }" > /etc/nginx/conf.d/default.conf

# Kopier den færdige applikationskode (din index.html-fil) ind i Nginx' web-rod.
# I en CI/CD-pipeline vil denne fil være outputtet af en byggeproces.
COPY index.html /usr/share/nginx/html/index.html

# Eksponer den port, som Cloud Run vil lytte på.
EXPOSE 8080

# Kommandoen til at starte Nginx-serveren, når containeren starter.
# '-g "daemon off;"' sikrer, at Nginx kører i forgrunden, hvilket er et krav for container-baserede services.
CMD ["nginx", "-g", "daemon off;"]
