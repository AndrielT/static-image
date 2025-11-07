FROM ubuntu:22.04
LABEL maintainer="Andriel"

# Update and install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx git

# Remove default nginx content
RUN rm -Rf /var/www/html/*

# Clone the repo and checkout dev branch
RUN git clone -b dev https://github.com/AndrielT/static-image.git /var/www/html/

# Set proper permissions and ownership
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

# Ensure index.html exists
RUN cd /var/www/html/ && \
    if [ -f "navDrop.html" ]; then mv navDrop.html index.html; fi && \
    ls -la  # Verify files

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]