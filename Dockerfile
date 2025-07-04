FROM python:3.12-slim
WORKDIR /app
RUN pip install flask
COPY . .
CMD ["python3", "main.py"]