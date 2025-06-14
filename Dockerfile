FROM python:3.10-slim 
WORKDIR /app 
COPY requirements.txt . 
    pip install -r requirements.txt 
COPY . . 
CMD [\"gunicorn\", \"--bind\", \"0.0.0.0:\$PORT\", \"app:app\"] 
