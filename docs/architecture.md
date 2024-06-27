# Architectural requirements
## Architectural design strategy
We have opted to design based on our quality requirements. This strategy will ensure that the project upholds our quality requirements throughout its development and, by extent, always meets the needs of the client, naturally leading to their satisfaction. This also ensures that the client’s needs are always prioritised, rather than developing according to what’s easiest for the system or the like

## Architectural strategies
#### Asynchronous Messaging
The use of asynchronous messaging will allow the system to handle notifications, post uploads, and other tasks without blocking the main application or forcing the user to reload the page to view live updates. This will improve system responsiveness and user experience, as well as decouple components, making the system more scalable and maintainable.
##### Usage
- **Notifications (get/send):** Asynchronous messaging is perfect for handling notifications. When a user performs an action that triggers a notification (e.g., a new comment on a post, a like on a post, etc.), an event can be placed on a message queue. This allows the main application to continue processing other requests without waiting for the notification to be sent.
- **Chat discussion:** Asynchronous messaging will allow the user to send and receive messages on a forumn they are invlolved in without having to reload the page to view new outgoing and new incoming messages. This will allow for a more seamless user experience.

##### Benefits
- Improves system responsiveness and user experience.
- Decouples components, making the system more scalable and maintainable.
- Handles high loads effectively.

## Client-Server
The Client-Server architectural pattern is a fundamental design pattern for networked applications. It separates the client (front-end) from the server (back-end), allowing each to be developed and used independently. The client is responsible for the presentation layer (What the user sees), while the server (API and databse) handles the business logic and data access layer. This separation of concerns makes the system more modular and easier to maintain.
##### Usage
- **Viewing and Uploading Posts:** The client-server model is fundamental for retrieving and displaying posts. The client (web browser or mobile app) makes requests to the server, which processes the request, fetches data from the database, and sends the posts back to the client.
When a user uploads a post, the client sends the post data to the server, which then stores the post in the database to be viewed by other users.
- **Locating Vets and Pet Sitters:** The client sends a request with location data to the server, which then queries the database to fetch nearby vets and pet sitters. The server sends the results back to the client for display.
- **Search Users:** The client sends a request to the server with the search query which contains the name of a user the person wishes to find, and the server queries the database for users matching the search query. The server then sends the results back to the client for display.
- **Forums:** The client displays a list of forums which the user may select, the client then sends a request to the database to retrieve the posts in the forum. The server then sends the posts back to the client for display.
- **Profile Page:** The client sends a request to the server to retrieve the user's profile information, the server then queries the database for the user's profile information and sends it back to the client for display.

##### Benefits
- Separates concerns between the client (presentation layer) and the server (business logic and data access layer).
- Facilitates easier updates and maintenance, as changes to the server or client can be made independently.
- Enhances security by centralizing sensitive operations on the server.

## Component-Based
The Component-Based architectural pattern divides the system into smaller, reusable components that can be developed, tested, and maintained independently. This pattern promotes reusability, simplifies testing and debugging, and enhances scalability.
##### Usage
- **Navbar:** The Navbar component can be reused across multiple pages, providing consistent navigation and user experience.
- **Post Component:** The Post component can be used to display posts in the main feed as well as the user's profile page.
- **Theme change component:** The theme change component can be used multiple times to alter a specific part of the users customized website by reusing the same colour picker component.

##### Benefits
- Encourages reusability of components, reducing redundancy and development time.
- Simplifies testing and debugging by isolating components.
- Enhances scalability, as individual components can be updated or replaced without affecting the entire system.


## Architectural quality requirements
- **Availability:** The system should have at least 99% uptime for the essential services (notably database access for reading and making posts).
- **Usability:** The app and web interfaces should function smoothly on most devices, dynamically resizing interface elements to fit a reasonable variety of modern screen sizes.
- **Scalability:** Backend functionality should be implemented in part through Firebase’s functions, ensuring smooth horizontal scaling. The system should be able to handle at least 30 requests per second. 
- **Performance:** Firebase queries (especially database queries) should be optimised to only return the minimum data needed to fulfil a request, to avoid wasting bandwidth and memory on loading unnecessary information. 
- **Security:** Firestore Security rules should be used to ensure that users do not have access to sensitive data, using role-based access control.

## Architectural design and pattern

## Architectural constraints

## Technology choices
