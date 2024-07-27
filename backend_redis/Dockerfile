FROM python:3.10-slim

WORKDIR /app

# Скопіюйте файл requirements.txt у робочу директорію
COPY requirements.txt ./

# Встановіть залежності з requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Скопіюйте всі файли проєкту у робочу директорію
COPY . .

# Відкрийте порт 8000
EXPOSE 8000

# Вкажіть команду для запуску вашого застосунку
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
