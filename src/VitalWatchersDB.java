import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class VitalWatchersDB {

    // Define database connection parameters
    private static final String URL = "jdbc:mysql://localhost:3306/VitalWatchers?useSSL=false";
    private static final String USER = "root";
    private static final String PASSWORD = "20020353";

    public static void main(String[] args) {
        // Query Example: Run one of the SQL queries to fetch patient information
        String query = "SELECT First_name, Last_name, Age, Patient_status FROM PATIENTS";

        // Establish connection and execute the query
        try (Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            System.out.println("Connected to database!");

            // Print results from the query execution
            while (resultSet.next()) {
                System.out.println("Name: " + resultSet.getString("First_name") + " " + resultSet.getString("Last_name"));
                System.out.println("Age: " + resultSet.getInt("Age"));
                System.out.println("Status: " + resultSet.getString("Status"));
                System.out.println("-----");
            }

        } catch (SQLException e) {
            System.out.println("Connection or query failed!");
            e.printStackTrace();
        }
    }
}
