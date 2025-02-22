# Backend Developer Homework Assignment

## Objective

Build an **API-only Rails application** to manage companies and their addresses. The focus is on demonstrating your understanding of:

- Rails 8.0
- Advanced validations
- Building APIs with JSON responses

---

## Requirements

### Project Overview

You will build a **RESTful API** with the following features:

- A `Company` can have multiple `Addresses`.
- Add a company with multiple addresses in a single API request.
- Bulk import multiple companies (with addresses) from a CSV file via a dedicated endpoint.
- Validate input and handle errors gracefully.

---

### Project Setup

**Use:**

- Ruby **3.3**
- Rails **8.0**
- Minitest or RSpec for automated testing

---

## Data Models

### **Company**

| Attribute             | Type   | Constraints               |
| --------------------- | ------ | ------------------------- |
| `name`                | String | Required, max length: 256 |
| `registration_number` | Number | Required, unique          |

### **Address**

| Attribute     | Type   | Constraints |
| ------------- | ------ | ----------- |
| `street`      | String | Required    |
| `city`        | String | Required    |
| `postal_code` | String | Optional    |
| `country`     | String | Required    |

### **Relationships**

- A `Company` **has one or many** `Addresses`.
- There are **no** `Addresses` without an associated `Company`.

---

## Endpoints

### **1. Create a Company with Multiple Addresses**

### **2. Bulk Import Companies via CSV**

#### **Input Format**

CSV file structure:

```csv
name,registration_number,street,city,postal_code,country
Example Co,123456789,123 Main St,New York,10001,USA
Example Co,123456789,456 Elm St,Los Angeles,90001,USA
Another Co,987654321,789 Oak St,Chicago,60601,USA
```

#### **Requirements**

- The CSV **may contain multiple rows** for the same company (with different addresses).
- Parse the CSV and **create companies with their associated addresses**.
- Validate input (e.g., **no duplicate** `registration_number`).
- **Success Response**: Return the imported companies.
- **Error Handling**: Return meaningful error messages when validations fail.

---

## Testing

Write automated tests (**Minitest** or **RSpec**) for:

- Creating a company with addresses.
- Bulk importing companies from CSV.

---

## Delivery

Submit your code as a **public Git repository** (GitHub, GitLab, etc.).

---

## Notes

- Focus on **clean, readable code** and **clear API responses**.
- Use **vanilla Rails** or any gem you prefer.
- Follow the **"Rails Way"** or use custom implementations.
- If anything in the task is unclear, select the **simplest solution** in your opinion.
- If you want to **show off additional skills**, feel free to do so.

> 🕒 **The task is designed to take approximately 60 minutes.**
