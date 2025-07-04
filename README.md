## Instructions
### 🏠 Develop Locally 🏠
1. Run your app and view it in your browser @ `localhost` or `localhost:80`:
```
cd devportfolio
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
This will create a new swarm with our machine as the manager node. From a manager node (like our machine right now) we can execute the following commands:

docker swarm join-token worker
docker swarm join-token manager
These will give us the commands needed to join the swarm as a worker and manager node respectively. Those commands will look like this:

docker swarm join --token <token> <ip>:<port>
Where <token>, <ip> and <port> need to be replaced with the parameters given with the join-token command. Since manager nodes may also act as a worker node, you may continue using only your machine (in case you don’t have access to others). Once we have our swarm up we can deploy our stack with the following command:

docker stack deploy --compose-file docker-stack.yml my-portfolio
Here, the –compose-file flag (or -c) allows us to select the configuration file where we define our services, and we are naming the stack as “myapp”. As I mentioned earlier, this stack name will be used as a prefix for the services, containers, volumes and networks names. You can check this with the following command:

docker stack services my-portfolio
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
```
docker stack services my-portfolio
docker stack ps my-portfolio
docker service ls
docker service scale my-portfolio_updater=3
docker service scale my-portfolio_web=3
```
