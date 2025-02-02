using Vektorel.Northwind.Data.DTOs;
using Vektorel.Northwind.Data.Managers;

namespace Vektorel.Northwind.WinForm
{
    public partial class FrmProducts : Form
    {
        public FrmProducts()
        {
            InitializeComponent();
        }

        private void FrmProducts_Load(object sender, EventArgs e)
        {
            var nm = new NorthwindManager();
            cmbCategories.DataSource = nm.GetCategories();
            cmbCategories.DisplayMember = nameof(Category.CategoryName);

            cmbSuppliers.DataSource = nm.GetSuppliers();
            cmbSuppliers.DisplayMember = nameof(Supplier.CompanyName);
        }

        private void btnSearch_Click(object sender, EventArgs e)
        {
            var nm = new NorthwindManager();
            dgvProducts.DataSource = null;
            var category = cmbCategories.SelectedItem as Category;
            var supplier = cmbSuppliers.SelectedItem as Supplier;
            dgvProducts.DataSource = nm.GetProducts(category.CategoryID, supplier.SupplierID);
        }
    }
}
