
## Base Api Ror Project


This is the Base project. We can easily fork this project for rapid development


### User Module

It includes all the api's of user module


* Signup
  ```sh
  Base_URL/api/v1/users   POST Request
  ```
  - Body(row-data/form-data)
  {email: string, password: string, device_id: string, device_type: string}

* Login
  ```sh
  Base_URL/api/v1/users/login   POST Request
  ```
    - Body(row-data/form-data)
  {email: string, password: string}
  
* Create Profile
  ```sh
  Base_URL/api/v1/users   PUT Request
  ```
    - Body(form-data)
  {first_name: string, last_name: string, dob: datetime, country_code: string, phone: string, lat: decimal, lng: decimal, location: string, image: file}
  
* Forgot Password
  ```sh
  Base_URL/api/v1/users/forgot_password   PUT Request
  ```
  - Body(row-data/form-data)
  {email: string}
  

## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_




## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request



## Contact

Your Name - Tushar Bhatia - tushar.bhatia@netsetsoftware.com

Project Link: [git@bitbucket.org:netset-rapid-development/ror_basic_api.git](git@bitbucket.org:netset-rapid-development/ror_basic_api.git)


