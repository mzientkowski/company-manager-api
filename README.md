# Company Manager API

## Project Evolution

In the early stage this project started as an **Ruby interview homework task**, which ultimately helped me land my job. The original task description can be found [here](HOMETASK.md). Over time, it has evolved into a **polished playground** to battle-test new Rails features and experiment with improvements.

---

## How to Run

1. **Build and Start the Application**
    - Run the following command to build the Docker images and start the application:
      ```bash
      docker compose up --build
      ```

2. **Prepare Database**
    - Create database, run migrations:
      ```bash
      docker compose run app bundle exec rake db:prepare
      ```

3. **Access API Documentation**
    - Visit the Swagger API documentation at:  
      [http://localhost:3000/api-docs](http://localhost:3000/api-docs)

4. **Explore the API**
    - Use the documentation to test and interact with the API.

5. **Stop Application and Clean Up**
    - To stop and clean up all containers, networks, and volumes used by the application, run:
      ```bash
      docker compose down -v --remove-orphans
      ```

---
