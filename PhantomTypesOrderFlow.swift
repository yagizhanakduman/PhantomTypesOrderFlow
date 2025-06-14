//
//  PhantomTypesOrderFlow.swift
//  CaseStudyCleanSwift
//
//  Created by YAGIZHAN AKDUMAN on 14.06.2025.
//

import Foundation
import Combine

/// Async/Await + Combine-based checkout flow using Phantom Types

// MARK: - Phantom Type States
/// Represents the initial empty cart state.
enum EmptyCart {}
/// Indicates that one or more items have been added to the cart.
enum ItemsAdded {}
/// Represents the state where payment information has been provided.
enum PaymentProvided {}
/// Final state after an order has been placed.
enum OrderPlaced {}

// MARK: - Generic Order Structure

/// A type-safe generic Order that enforces state transitions via phantom types.
struct Order<State> {
    let items: [String]
    let totalAmount: Double
    let paymentInfo: String?

    /// Internal initializer, used during state transitions.
    fileprivate init(items: [String], totalAmount: Double, paymentInfo: String?) {
        self.items = items
        self.totalAmount = totalAmount
        self.paymentInfo = paymentInfo
    }
    
}

// MARK: - State Extensions for Order
extension Order where State == EmptyCart {

    /// Starts a new empty cart.
    static func start() -> Order<EmptyCart> {
        Order<EmptyCart>(items: [], totalAmount: 0, paymentInfo: nil)
    }

    /// Adds an item to the cart.
    func addItem(_ item: String, price: Double) -> Order<ItemsAdded> {
        print("🧺 '\(item)' added to cart for $\(price)")
        return Order<ItemsAdded>(items: [item], totalAmount: price, paymentInfo: nil)
    }
    
}

extension Order where State == ItemsAdded {

    /// Adds payment information to the order.
    func enterPaymentDetails(_ card: String) -> Order<PaymentProvided> {
        print("💳 Payment method '\(card)' saved.")
        return Order<PaymentProvided>(items: items, totalAmount: totalAmount, paymentInfo: card)
    }
    
}

extension Order where State == PaymentProvided {

    /// Finalizes the order and returns receipt details.
    func placeOrder() -> Order<OrderPlaced> {
        print("✅ Order placed successfully.")
        print("🧾 Receipt: Items - \(items), Total - $\(totalAmount), Paid with - \(paymentInfo!)")
        return Order<OrderPlaced>(items: items, totalAmount: totalAmount, paymentInfo: paymentInfo)
    }
    
}

// MARK: - Async Order Flow

/// A type-safe async order flow implementation using phantom types.
struct AsyncOrder<State> {
    let items: [String]
    let totalAmount: Double
    let paymentInfo: String?

    fileprivate init(items: [String], totalAmount: Double, paymentInfo: String?) {
        self.items = items
        self.totalAmount = totalAmount
        self.paymentInfo = paymentInfo
    }
}

extension AsyncOrder where State == EmptyCart {

    /// Starts a new empty async cart.
    static func start() -> AsyncOrder<EmptyCart> {
        AsyncOrder<EmptyCart>(items: [], totalAmount: 0, paymentInfo: nil)
    }

    /// Asynchronously adds an item to the cart.
    func addItem(_ item: String, price: Double) async -> AsyncOrder<ItemsAdded> {
        try? await Task.sleep(nanoseconds: 500_000_000)
        print("🧺 '\(item)' added")
        return AsyncOrder<ItemsAdded>(items: [item], totalAmount: price, paymentInfo: nil)
    }
}

extension AsyncOrder where State == ItemsAdded {

    /// Asynchronously enters payment details.
    func enterPaymentDetails(_ card: String) async -> AsyncOrder<PaymentProvided> {
        try? await Task.sleep(nanoseconds: 300_000_000)
        print("💳 Payment: \(card)")
        return AsyncOrder<PaymentProvided>(items: items, totalAmount: totalAmount, paymentInfo: card)
    }
}

extension AsyncOrder where State == PaymentProvided {

    /// Asynchronously places the order.
    func placeOrder() async -> AsyncOrder<OrderPlaced> {
        try? await Task.sleep(nanoseconds: 700_000_000)
        print("✅ Order Placed! Total: \(totalAmount)")
        return AsyncOrder<OrderPlaced>(items: items, totalAmount: totalAmount, paymentInfo: paymentInfo)
    }
    
}

// MARK: - Combine Order Flow

/// A Combine-powered reactive order flow using phantom types.
struct CombineOrder<State> {
    let items: [String]
    let totalAmount: Double
    let paymentInfo: String?

    fileprivate init(items: [String], totalAmount: Double, paymentInfo: String?) {
        self.items = items
        self.totalAmount = totalAmount
        self.paymentInfo = paymentInfo
    }
    
}

extension CombineOrder where State == EmptyCart {

    /// Starts a new empty Combine cart.
    static func start() -> CombineOrder<EmptyCart> {
        CombineOrder<EmptyCart>(items: [], totalAmount: 0, paymentInfo: nil)
    }

    /// Adds an item to the cart as a Combine publisher.
    func addItem(_ item: String, price: Double) -> AnyPublisher<CombineOrder<ItemsAdded>, Never> {
        Just(CombineOrder<ItemsAdded>(items: [item], totalAmount: price, paymentInfo: nil))
            .delay(for: 0.5, scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { _ in print("🧺 '\(item)' added") })
            .eraseToAnyPublisher()
    }
    
}

extension CombineOrder where State == ItemsAdded {

    /// Adds payment info to the cart as a Combine publisher.
    func enterPaymentDetails(_ card: String) -> AnyPublisher<CombineOrder<PaymentProvided>, Never> {
        Just(CombineOrder<PaymentProvided>(items: items, totalAmount: totalAmount, paymentInfo: card))
            .delay(for: 0.3, scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { _ in print("💳 Payment: \(card)") })
            .eraseToAnyPublisher()
    }
    
}

extension CombineOrder where State == PaymentProvided {

    /// Places the order as a Combine publisher.
    func placeOrder() -> AnyPublisher<CombineOrder<OrderPlaced>, Never> {
        Just(CombineOrder<OrderPlaced>(items: items, totalAmount: totalAmount, paymentInfo: paymentInfo))
            .delay(for: 0.7, scheduler: RunLoop.main)
            .handleEvents(receiveOutput: { _ in print("✅ Order placed!") })
            .eraseToAnyPublisher()
    }
    
}
