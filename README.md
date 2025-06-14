# Phantom Types Order Flow in Swift

This repository demonstrates how to implement a **type-safe, compile-time verified order flow** in Swift using **phantom types**, with three usage styles:

- `Order<State>` — Classic compile-time checked order flow
- `AsyncOrder<State>` — Async/Await-based progressive flow
- `CombineOrder<State>` — Reactive Combine pipeline

---

## Motivation

Phantom types allow you to enforce business logic **at compile time** by encoding state transitions into generic types. In this example, a simple e-commerce order process is implemented as:

EmptyCart → ItemsAdded → PaymentProvided → OrderPlaced

Each state has its own type, preventing invalid transitions like:

- Placing an order before providing payment
- Providing payment before adding an item

---

## Order States

```swift
enum EmptyCart {}
enum ItemsAdded {}
enum PaymentProvided {}
enum OrderPlaced {}
```

---

## Basic Order<State> Usage

```swift
let empty = Order<EmptyCart>.start()
let withItems = empty.addItem("MacBook Pro", price: 2499.99)
let withPayment = withItems.enterPaymentDetails("Visa **** 1234")
let placed = withPayment.placeOrder()
```
> Attempting to call .placeOrder() directly on empty or withItems will cause a compile-time error.

---

## Async/Await Flow

```swift
Task {
    let empty = AsyncOrder<EmptyCart>.start()
    let withItems = await empty.addItem("iPhone 15 Pro", price: 1799.99)
    let withPayment = await withItems.enterPaymentDetails("MasterCard **** 4321")
    let placed = await withPayment.placeOrder()
}
```
> Simulates delay using Task.sleep to mimic API latency.

---

## Combine Flow

```swift
import Combine

var cancellables = Set<AnyCancellable>()

CombineOrder<EmptyCart>.start()
    .addItem("Magic Keyboard", price: 299)
    .flatMap { $0.enterPaymentDetails("Amex **** 9876") }
    .flatMap { $0.placeOrder() }
    .sink(receiveValue: { _ in
        print("🎉 Combine order placed.")
    })
    .store(in: &cancellables)
```
> Uses Just + delay(for:) + handleEvents to simulate asynchronous Combine streams.

---

## Why Phantom Types?

- Compile-time safety: Invalid flows are impossible
- Cleaner API: You model state transitions explicitly
- Flexible design: Works with async/await, Combine, or traditional code
- Zero runtime state errors

---
