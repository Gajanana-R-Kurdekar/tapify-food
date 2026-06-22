package com.instafood.dao;

import java.util.List;

import com.instafood.model.User;

public interface UserDAO {

    // INSERT
    int addUser(User user);

    // FETCH SINGLE USER
    User getUserById(int id);

    // FETCH ALL USERS
    List<User> getAllUsers();

    // UPDATE USER
    int updateUser(User user);

    // DELETE USER
    int deleteUser(int id);

    // FETCH USER BY EMAIL
    User getUserByEmail(String email);
}
