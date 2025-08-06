## Handling Money / Currency

To ensure accuracy and consistency when dealing with money, I made the following decisions:

    - Use of Decimal: All monetary values are stored and calculated using the Decimal library instead of floating point numbers to prevent rounding errors and ensure precise arithmetic.

    - User Input Normalization: When accepting user input (e.g: "12.30"), the input is sanitized and converted to a Decimal before any computation or persistence.

## Supporting Multiple Currencies

To support multiple currencies in the future, I would:

    - Introduce a currency field in the Category and Expense schema.
    - Use currency codes (like USD, EUR, RWF) for standardization.
    - Add a currency conversion service, e.g: consuming an exchange rates API to convert values to a base currency for reporting.
    - Allow dynamic toggling between currencies in the UI.
    - Cache exchange rates using GenServers or ETS to reduce API calls and improve performance. I made something similar in this repo [text](https://github.com/NtwaliHeritier/payment_server)

## Architectural Decisions

    - LiveView for Interactivity: I chose Phoenix LiveView to avoid writing separate JavaScript code for interactivity, and instead leveraged server-rendered, real-time UIs.

    - Streams for Real-Time Updates: The use of stream/3 ensures minimal DOM diffing and efficient updates when new categories are added.

    - PubSub for Real-Time Data Sync: Categories subscribe to updates via PubSub, ensuring that all connected users get real-time updates when a new category is created.

    - Separation of Concerns: Business logic (e.g: category creation) lives in the context module (ExpenseTracker.Categories), while UI logic remains in the LiveView.

## Trade-offs and Shortcuts

Due to time constraints, I made the the trade-off of:

    - Limited test coverage for edge cases: Core behaviors like creation, listing, and validation are tested, but edge cases (e.g: extremely large budgets) are not yet covered.

## Testing Strategy

The testing approach includes:

    - LiveView Integration Tests: Using Phoenix.LiveViewTest, I wrote tests that simulate user interaction (form submissions, patching routes, etc.) and verify the rendered HTML.

    - PubSub Simulation: handle_info/2 is tested by manually sending messages to the LiveView process and asserting that the new category is rendered.

    - Positive and Negative Form Tests: I tested both valid and invalid form submissions to ensure validation logic works as expected.
