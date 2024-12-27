# Company Manager API

## How to Run

1. **Build and Start the Application**
    - Run the following command to build the Docker images and start the application:
      ```bash
      docker compose up --build

2. **Prepare Database**
    - Create database, run migrations:

      ```bash
      docker compose run app bundle exec rake db:prepare

3. **Access API Documentation**
    - Visit the Swagger API documentation at:  
      [http://localhost:3000/api-docs](http://localhost:3000/api-docs)

4. **Explore the API**
    - Use the documentation to test and interact with the API.

5.  **Stop Application and Clean Up**
    - To stop and clean up all containers, networks, and volumes used by the application, run:

     ```bash
     docker compose down -v --remove-orphans

## Taken Solution and Further Steps

### Current Features
1. **Transactional Insert**:
    - All records are imported or none, ensuring data integrity.
2. **Small File Support**:
    - Assumes small file sizes, processes synchronously.

### Further Steps
1. **Upsert Support**:
    - Allow updating existing records and adding missing addresses during import.
2. **File Size Validation**:
    - Enforce file size limits.
3. **Async Flow**:
    - Handle large files asynchronously, returning an `import_id` to track progress.
4. **Imported Companies**:
    - `GET /companies?import_id={import_id}`: Retrieve results of an asynchronous import.
