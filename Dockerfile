# Use an official Node.js runtime as a parent image
FROM node:18-alpine

WORKDIR /srv/app

# Copy only package.json
COPY package.json ./

# Install dependencies with npm
RUN npm install

# Copy the rest of your app's source code
COPY . .

# Build the app (for Strapi)
RUN npm run build

EXPOSE 1337

CMD ["npm", "start"]