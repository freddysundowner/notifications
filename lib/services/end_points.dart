const baseUrl = "http://52.43.151.113";
const imageUrl = baseUrl + "/public/img/";
const rooms = baseUrl + "/rooms";
const user = baseUrl + "/users";

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

const allUsers = user + "/";
