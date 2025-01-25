using Microsoft.Data.SqlClient;

namespace Vektorel.Sql.FormApp
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            var connection = new SqlConnection("Server=.;Database=Northwind;User Id=va249;Password=1q2w3e4R!;TrustServerCertificate=true");
            connection.Open();
            var query = @"SELECT CategoryID, CategoryName FROM Categories";
            var command = new SqlCommand(query, connection);
            var reader = command.ExecuteReader();
            while (reader.Read())
            {
                comboBox1.Items.Add(new Category
                {
                    Id = Convert.ToInt32(reader[0]),
                    Name = reader[1].ToString()
                });
            }
            comboBox1.DisplayMember = nameof(Category.Name);
            command.Dispose();
            connection.Close();
        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            var connection = new SqlConnection("Server=.;Database=Northwind;User Id=va249;Password=1q2w3e4R!;TrustServerCertificate=true");
            connection.Open();
            var category = comboBox1.SelectedItem as Category;
            var query = @"SELECT ProductName, UnitPrice, UnitsInStock FROM Products WHERE CategoryID = " + category.Id;
            var command = new SqlCommand(query, connection);
            var reader = command.ExecuteReader();
            var list = new List<Product>();
            while (reader.Read())
            {
                list.Add(new Product
                {
                    Name = reader[0].ToString(),
                    Price = Convert.ToDouble(reader[1]),
                    Stock = Convert.ToDouble(reader[2]),
                });
            }
            dataGridView1.DataSource = null;
            dataGridView1.DataSource = list;

            command.Dispose();
            connection.Close();
        }
    }
}


class Category
{
    public int Id { get; set; }
    public string Name { get; set; }
}

class Product
{
    public string Name { get; set; }
    public double Price { get; set; }
    public double Stock { get; set; }
}