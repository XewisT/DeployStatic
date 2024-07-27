FROM python:3.10-slim

WORKDIR /app

# Скопіюйте файл requirements.txt у робочу директорію
COPY backend_rds/requirements.txt /app/

# Встановіть залежності з файлу requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Скопіюйте всі файли проєкту у робочу директорію
COPY . /app/

# Відкрийте порт 8000 для доступу до вашого застосунку
EXPOSE 8000

# Вкажіть команду для запуску вашого застосунку з затримкою 10 секунд
CMD ["sh", "-c", "sleep 10 && python manage.py runserver 0.0.0.0:8000"]
