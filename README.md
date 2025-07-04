## Instructions
### 🏠 Develop Locally 🏠
1. Run your app and view it in your browser @ `localhost` or `localhost:80`:
```
cd dev_portfolio_simplified
docker compose up
```
2. update `init_db.py` with your personal information and projects.
3. update `static/style.css` with your favourite styling.
4. update `static/script.js` with your JavaScript browser intercations. 
5. saving each of the above files, and refreshing the web page - will automatically update your website locally.

### 🚀 Publish on a Remote Server 🚀
1. switch to a production server like Green Unicorn, by updating your Dockerfile:
```
FROM python:3.12-slim
WORKDIR /app
RUN pip install flask
RUN pip install gunicorn
COPY . .
CMD ["gunicorn", "--workers=5", "--bind", "0.0.0.0:5000", "main:app"]
```
2. pre-build a Docker image, to later specify it in your docker-compose file:
```
docker build -t my-portfolio .
```
3. update docker-compose file with the pre-build image:
```
services:
  web:
    image: my-portfolio:latest
    ports:
      - "80:5000"
    volumes:
      - ./:/app
    deploy:
      restart_policy:
        condition: any

  updater:
    image: my-portfolio:latest
    command: ["tail", "-f", "/dev/null"]
    volumes:
      - ./:/app
    deploy:
      restart_policy:
        condition: any
```
4. activate swarm more and deploy the GUI and database services in a stack:
```
docker build -t my-portfolio .
docker swarm init
docker stack deploy -c docker-compose.yml my-portfolio
```
5. update `init_db.py` and save it.
6. find container id of the database updater service with: `docker ps`
7. update database service without collapsing the application
```
docker exec [CONTAINER ID GOES HERE] python3 /app/init_db.py
```
