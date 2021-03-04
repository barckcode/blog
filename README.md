# Steps for production without automation:
- Allow access only whit the allowed user
- create Vhost: helmcode.com
- git clone https://github.com/helmcode/app.git helmcode.com
- copy prod.env to aragon
- set DB_PASSWORD env var
- Dar permisos de conexión remota al usuario de MySQL
- Importar la BBDD


# Deploy steps (temporary)
- git pull
- docker-compose -f docker-compose.yml restart flask

> Be careful whit static files in css

### Git branches
main -> Prod
dev  -> Development


# To investigate
- https://flask.palletsprojects.com/en/1.1.x/tutorial/deploy/
- https://docs.docker.com/engine/swarm/
