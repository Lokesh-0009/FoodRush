package com.foodRush.DAO;

import java.util.List;
import com.foodRush.model.Driver;

public interface DriverDAO {

	int addDriver(Driver driver);

	Driver getDriver(int driverID);

	Driver getDriverByUserId(int userID);

	List<Driver> getAllDrivers();

	List<Driver> getAvailableDrivers();

	void updateDriver(Driver driver);

	void updateDriverStatus(int driverID, String status);

	void deleteDriver(int driverID);
}
