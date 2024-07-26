# Use the official Python image from the Docker Hub

# FROM python:3
FROM laudio/pyodbc:3.0.0

# Make a new directory to put our code in.

RUN mkdir /code

# Change the working directory.

WORKDIR /code

# Copy to code folder

COPY . /code/
# Installing system utilities
RUN apt-get update && apt-get install -y \
    curl apt-utils
# Install the requirements.
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

EXPOSE 8000
# Run the application:

CMD python manage.py runserver 0.0.0.0:8000