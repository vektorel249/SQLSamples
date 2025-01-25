using Microsoft.Data.SqlClient;

namespace Vektorel.SqlOnConsole
{
    internal class Program
    {
        static void Main(string[] args)
        {
            var connection = new SqlConnection("Server=.;Database=Northwind;User Id=va249;Password=1q2w3e4R!;TrustServerCertificate=true");
            connection.Open();
            var query = @"SELECT p.ProductName, p.UnitPrice
                          FROM Products AS p
                          INNER JOIN Categories AS c ON p.CategoryID = c.CategoryID
                          WHERE c.CategoryID = 1";
            var command = new SqlCommand(query, connection);
            var reader = command.ExecuteReader();
            while (reader.Read())
            {
                Console.WriteLine($"{reader[1]} - {reader[0]}");
            }
            command.Dispose();
            connection.Close();
        }
    }
}
