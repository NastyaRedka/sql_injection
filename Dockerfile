# Використовуємо офіційний образ PHP з Apache
FROM php:8.1-apache

# Встановлюємо необхідні системні залежності
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    curl \
    gnupg \
    unixodbc-dev \
    libxml2-dev \
    wget \
    software-properties-common

# Додаємо репозиторій Microsoft
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Встановлення Microsoft ODBC Driver
RUN apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
    && ACCEPT_EULA=Y apt-get install -y mssql-tools18

# Додаємо шлях для інструментів
ENV PATH="/opt/mssql-tools18/bin:${PATH}"

# Встановлення PHP-розширень для роботи з MS SQL
RUN pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv

# Увімкнути PHP для обробки .html файлів
RUN echo "AddType application/x-httpd-php .html" >> /etc/apache2/apache2.conf

# Копіюємо поточну директорію в /var/www/html
COPY . /var/www/html

# Встановлюємо робочу директорію
WORKDIR /var/www/html

# Встановлюємо права на файли
RUN chown -R www-data:www-data /var/www/html

# Відкриваємо порт
EXPOSE 80

# Запускаємо сервер Apache
CMD ["apache2-foreground"]