//
//  ServiceProtocol.swift
//  TvoyaAptekaiOS
//
//  Created by Marty McFly on 23.03.2018.
//  Copyright © 2018 Marty McFly. All rights reserved.
//

import Foundation
import RxSwift

protocol ActualsAPIProtocol {
    func getActualCategories() -> Single<[ActualCategory]>
    func getActualCards(actualId: Int, cityId: Int, from: UInt, count: UInt) -> Single<[Drug]>
}

protocol FavoritesAPIProtocol {
    func getFavorites(token: String, cityId: Int, from: Int, count: Int?) -> Single<[Drug]>
    func addToFavorite(token: String, drugId: Int) -> Completable
    func deleteFromFavorite(token: String, drugId: Int) -> Completable
}

protocol ArticleAPIProtocol {
    func getArticlesList(from: Int, count: Int) -> Single<[Article]>
    func getArticle(cityId: Int, articleId: Int) -> Single<Article>
}

protocol PromoAPIProtocol {
    func getPromotionList(cityId: Int, from: Int, count: Int) -> Single<[Promotion]>
    func getPromotion(cityId: Int, promotionId: Int) -> Single<Promotion>
}

protocol BonusCardAPIProtocol {
    func getBonusCard(token: String) -> Single<BonusCard>
    func activateBonusCard(token: String, cardNum: String) -> Completable
}

protocol CitiesAPIProtocol {
    func getAllRegionsAndCities() -> Single<[Region]>
}

protocol DrugStoresAPIProtocol {
    func getAllDrugStores(cityId: Int) -> Single<[DrugStore]>
    func getDrugStore(storeId: Int) -> Single<DrugStore>
}

protocol DrugCategoriesAPIProtocol {
    func getAllCategoriesTree() -> Single<[DrugCategory]>
}

protocol CartAPIProtocol {
    func getCart(token: String, cityId: Int, promocode: String?) -> Single<Cart>
    func addToCart(token: String, drugStoreId: Int, drugId: Int, count: Int) -> Completable
    func deleteFromCart(drugStoreId: Int, drugId: Int, count: UInt) -> Completable
    func deleteTradeFromCart(token: String, drugsId: [Int]) -> Completable
}

protocol OrdersAPIProtocol {
    func getAllOrders(token: String, withStatus: Order.State?) -> Single<[Order]>
    func getOrder(token: String, orderId: Int) -> Single<Order>
    func cancelOrder(token: String, orderId: Int) -> Completable
    func createOrderFromCart(token: String, promocode: String?) -> Single<[Order]>
}

protocol UserAPIProtocol {
    //Регистрация
    func validateUserInfo(phone: String, password: String, passwordConfirm: String) -> Completable
    func registerUser(phone: String, password: String, passwordConfirm: String, smsCode: String) -> Single<Token>
    func requestSms(phone: String) -> Completable
    func restorePassword(phone: String, password: String, passwordConfirm: String, smsCode: String) -> Completable

    // Авторизация
    func logIn(phone: String, password: String) -> Single<Token>
    func updateToken(token: String) -> Single<Token?>
    func logOut(token: String) -> Completable
    
    // Использование
    func updateUserInfo(token: String, userInfo: UserInfo?, passwordInfo: NewPasswordContainer?) -> Completable
    func changePassword(token: String, oldPassword: String, newPassword: String, newPasswordConfirm: String) -> Completable
    func getUser(token: String) -> Single<UserInfo>
}

protocol SearchAPIProtocol {
    func getSearchResults(cityId: Int, query: String) -> Single<SearchResults>
}

protocol DrugAPIProtocol {
    func getDrugShortCards(cityId: Int, inCategory: Int, from: Int, count: Int, filter: DrugFilter?) -> Single<[Drug]>
    func getDrug(cityId: Int, drugId: Int) -> Single<Drug?>
    func getPricesAndManufacturers(cityId: Int) -> Single<ManufacturersAndPrice>
}

protocol FeedbackAPIProtocol {
    func sendFeedback(phone: String, text: String, name: String) -> Completable
}

protocol DeviceTokenAPIProtocol {
    func send(token: String, pushToken: String) -> Completable
}
