package com.tap.utility.dbconnection;

import java.sql.Connection;

import com.tap.utility.dbconnection.DBConnection;

public class ConnectionTest {

    public static void main(String[] args) {

        Connection con = DBConnection.getConnection();

        if (con != null) {
            System.out.println("Connection established successfully!");
        } else {
            System.out.println("Connection failed!");
        }
    }
}
