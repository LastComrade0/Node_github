FROM node
LABEL authors="Yann Mulonda"
# update dependencies and install curl
RUN [ -f /etc/apt/sources.list ] || echo "deb http://cdn-fastly.deb.debian.org/debian bookworm main" > /etc/apt/sources.list
RUN sed -i 's|http://deb.debian.org|http://cdn-fastly.deb.debian.org|g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*
# Create app directory
WORKDIR /app
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
# COPY package*.json ./ \
#     ./source ./

# This will copy everything from the source path 
# --more of a convenience when testing locally.
COPY . .
# update each dependency in package.json to the latest version
RUN npm install -g npm-check-updates \
    ncu -u \
    npm install \
    npm install express \
    npm install babel-cli \
    npm install babel-preset \
    npm install babel-preset-env
# If you are building your code for production
RUN npm ci --only=production
# Bundle app source
COPY . /app
EXPOSE 3000
CMD [ "babel-node", "app.js" ]