using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Vektorel.Northwind.Data.DTOs;

namespace Vektorel.Northwind.Data.Managers
{
    public class NorthwindManager
    {
        private readonly SqlConnection connection;
        public NorthwindManager()
        {
            connection = new SqlConnection("Server=.;Database=Northwind;User Id=arda;Password=123;TrustServerCertificate=true");
        }

        public List<Category> GetCategories()
        {
            var categories = new List<Category>();
            var query = "SELECT CategoryID, CategoryName FROM Categories";
            var command = new SqlCommand(query, connection);
            connection.Open();
            var reader = command.ExecuteReader();
            while (reader.Read())
            {
                var c = new Category()
                {
                    CategoryID = Convert.ToInt32(reader["CategoryId"]),
                    CategoryName = reader["CategoryName"].ToString(),
                };
                categories.Add(c);
            }
            command.Dispose();
            connection.Close();
            return categories;
        }

        public List<Supplier> GetSuppliers()
        {
            var suppliers = new List<Supplier>();
            var query = "SELECT SupplierID AS ID, CompanyName AS Name FROM Suppliers";
            var command = new SqlCommand(query, connection);
            connection.Open();
            var reader = command.ExecuteReader();
            while (reader.Read())
            {
                var c = new Supplier()
                {
                    SupplierID = Convert.ToInt32(reader["ID"]),
                    CompanyName = reader["Name"].ToString(),
                };
                suppliers.Add(c);
            }
            command.Dispose();
            connection.Close();
            return suppliers;
        }

        public List<Product> GetProducts(int categoryID, int supplierID)
        {
            var products = new List<Product>();
            var query = $@"SELECT 
                               ProductID, ProductName, UnitPrice, UnitsInStock 
                          FROM Products
                          WHERE CategoryID = {categoryID} AND SupplierID = {supplierID}";
            var command = new SqlCommand(query, connection);
            connection.Open();
            var reader = command.ExecuteReader();
            while (reader.Read())
            {
                var c = new Product()
                {
                    ProductID = Convert.ToInt32(reader["ProductID"]),
                    ProductName = reader["ProductName"].ToString(),
                    UnitPrice = Convert.ToDecimal(reader["UnitPrice"]),
                    UnitsInStock = Convert.ToInt32(reader["UnitsInStock"])
                };
                products.Add(c);
            }
            command.Dispose();
            connection.Close();
            return products;
        }
    }
}
