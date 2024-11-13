# Використовуємо офіційний образ PHP з Apache
FROM php:8.0-apache

# Оновлюємо системні пакети та встановлюємо необхідні залежності для SQL Server
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    ca-certificates \
    apt-transport-https \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list | tee /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 \
    && apt-get install -y unixodbc-dev \
    && apt-get install -y libxml2-dev

# Встановлюємо PHP-розширення для SQL Server (pdo_sqlsrv та sqlsrv)
RUN apt-get install -y gcc g++ make autoconf libc-dev pkg-config \
    && pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

# Встановлюємо SQLite (якщо потрібно для зворотної сумісності)
RUN apt-get install -y libsqlite3-dev sqlite3 && docker-php-ext-install pdo pdo_sqlite

# Увімкнути PHP для обробки .html файлів
RUN echo "AddType application/x-httpd-php .html" >> /etc/apache2/apache2.conf

# Копіюємо поточну директорію (де знаходиться Dockerfile) в /var/www/html в контейнері
COPY . /var/www/html

# Встановлюємо робочу директорію
WORKDIR /var/www/html

# Встановлюємо права на файли
RUN chown -R www-data:www-data /var/www/html

# Відкриваємо порт 80
EXPOSE 80

# Запускаємо сервер Apache
CMD ["apache2-foreground"]
