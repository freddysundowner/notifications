const baseUrl = "http://52.43.151.113";

const imageUrl = "";
const rooms = baseUrl + "/rooms";
const favorite = baseUrl + "/favorite/";
const tokenPath = rooms + "/agora/rooom/generatetoken";
const user = baseUrl + "/users";
const shop = baseUrl + "/shop/";
const product = baseUrl + "/products/";
const singleproduct = product + "/product/";
const authenticatation = baseUrl + "/authenticate";
const register = baseUrl + "/registerv1";
const address = baseUrl + "/address/";
const addresses = address + "/all/";
const activities = baseUrl + "/activities";
const transactions = baseUrl + "/transactions";
const orders = baseUrl + "/orders";
const notifications = baseUrl + "/notifications";

const singleproductqtycheck = singleproduct + "product/qtycheck/";
const allRooms = rooms + "/get/all/";
const allEvents = rooms + "/events";
const myEvents = rooms + "/myevents";
const roomById = rooms + "/rooms/";
const record = rooms + "/record/";
const stoprecording = rooms + "/stoprecording/";
const eventById = rooms + "/event/";
const roomByUser = rooms + "/get/all/"; //Add user Id
const roomByShop = rooms + "/get/all/shops/"; //Add shop Id
const updateRoom = rooms + "/rooms/";
const updateRoomNew = rooms + "/rooms/updatenew/";
const roomNotication = rooms + "/rooms/roomnotifications/";
const createRoom = rooms + "/";
const createEventE = rooms + "/newevent/";
const deleteRoom = rooms + "/rooms/";
const addUserToRoom = rooms + "/user/add/";
const removeUserFromRoom = rooms + "/user/remove/";
const removeSpeaker = rooms + "/speaker/remove/";
const removeUserFromAudience = rooms + "/audience/remove/";
const removeHost = rooms + "/host/remove/";
const removeUserFromRaisedHands = rooms + "/raisedhans/remove/";

const updateshop = shop + "shop/";
const myshopproduct = product + "myshop/";
const allShops = shop;
const searchShopByName = shop + "search/";
const updateproduct = product + "products/";
const updateproductimages = product + "images/";

const userById = user + "/";
const userSendGift = user + "/sendgift";
const userWithdraw = user + "/withdraw/requests";
const userFollowers = user + "/followers/";
const followersfollowing = user + "/followersfollowing/";
const userFollowing = user + "/following/";
const followUser = user + "/follow/";
const unFollowUser = user + "/unfollow/";
const editUser = user + "/";
const upgradeUser = user + "/upgrade/";
const allUsers = user + "/";
const searchUsersByFirstName = user + "/search/";
const followersfollowingsearch = user + "/followersfollowing/search/";

const userProducts = product + "/get/all/";

const userActivities = activities + "/to/";

const userTransactions = transactions + "/";

const userOrders = orders + "/";
const shopOrders = orders + "/all/shop/";
const updateOrders = orders + "/orders/";
