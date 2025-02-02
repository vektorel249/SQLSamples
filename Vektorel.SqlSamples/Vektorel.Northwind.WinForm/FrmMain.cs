namespace Vektorel.Northwind.WinForm
{
    public partial class FrmMain : Form
    {
        public FrmMain()
        {
            InitializeComponent();
        }

        private void msbProducts_Click(object sender, EventArgs e)
        {
            var f = new FrmProducts();
            f.MdiParent = this;
            f.Show();
        }
    }
}
