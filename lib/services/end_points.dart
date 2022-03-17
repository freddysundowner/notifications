const baseUrl = "http://52.43.151.113";
const tokenPath =
    "http://us-central1-gisthouse-887e3.cloudfunctions.net/generateagoratoken";
const imageUrl = baseUrl + "/public/img/";
const rooms = baseUrl + "/rooms";
const user = baseUrl + "/users";
const shop = baseUrl + "/shop/";
const product = baseUrl + "/products/";
const authenticatation = baseUrl + "/authenticate";
const register = baseUrl + "/registerv1";
const address = baseUrl + "/address/";
const addresses = address + "/all/";
const activities = baseUrl + "/activities";

const allRooms = rooms + "/";
const roomById = rooms + "/rooms/";
const roomByUser = rooms + "/get/all/"; //Add user Id
const roomByShop = rooms + "/get/all/shops/"; //Add shop Id
const updateRoom = rooms + "/rooms/";
const createRoom = rooms + "/";
const deleteRoom = rooms + "/rooms/";
const addUserToRoom = rooms + "/user/add/";
const removeUserFromRoom = rooms + "/user/remove/";
const removeSpeaker = rooms + "/speaker/remove/";
const removeUserFromAudience = rooms + "/audience/remove/";
const removeUserFromRaisedHands = rooms + "/raisedhans/remove/";

const updateshop = shop + "shop/";
const allShops = shop;
const searchShopByName = shop + "search/";
const updateproduct = product + "products/";
const updateproductimages = product + "images/";

const allUsers = user + "/";
const searchUsersByFirstName = user + "/search/";

const userProducts = product + "/get/all/";

const userActivities = activities + "/to/";
