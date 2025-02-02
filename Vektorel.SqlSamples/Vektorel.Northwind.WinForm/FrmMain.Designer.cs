namespace Vektorel.Northwind.WinForm
{
    partial class FrmMain
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            menuStrip1 = new MenuStrip();
            uygulamaToolStripMenuItem = new ToolStripMenuItem();
            hakkındaToolStripMenuItem = new ToolStripMenuItem();
            çıkışToolStripMenuItem = new ToolStripMenuItem();
            ürünToolStripMenuItem = new ToolStripMenuItem();
            yeniToolStripMenuItem = new ToolStripMenuItem();
            msbProducts = new ToolStripMenuItem();
            siparişToolStripMenuItem = new ToolStripMenuItem();
            yeniToolStripMenuItem1 = new ToolStripMenuItem();
            siparişlerToolStripMenuItem = new ToolStripMenuItem();
            raporlarToolStripMenuItem = new ToolStripMenuItem();
            menuStrip1.SuspendLayout();
            SuspendLayout();
            // 
            // menuStrip1
            // 
            menuStrip1.Items.AddRange(new ToolStripItem[] { uygulamaToolStripMenuItem, ürünToolStripMenuItem, siparişToolStripMenuItem });
            menuStrip1.Location = new Point(0, 0);
            menuStrip1.Name = "menuStrip1";
            menuStrip1.Size = new Size(574, 24);
            menuStrip1.TabIndex = 1;
            menuStrip1.Text = "menuStrip1";
            // 
            // uygulamaToolStripMenuItem
            // 
            uygulamaToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { hakkındaToolStripMenuItem, çıkışToolStripMenuItem });
            uygulamaToolStripMenuItem.Name = "uygulamaToolStripMenuItem";
            uygulamaToolStripMenuItem.Size = new Size(73, 20);
            uygulamaToolStripMenuItem.Text = "Uygulama";
            // 
            // hakkındaToolStripMenuItem
            // 
            hakkındaToolStripMenuItem.Name = "hakkındaToolStripMenuItem";
            hakkındaToolStripMenuItem.Size = new Size(180, 22);
            hakkındaToolStripMenuItem.Text = "Hakkında";
            // 
            // çıkışToolStripMenuItem
            // 
            çıkışToolStripMenuItem.Name = "çıkışToolStripMenuItem";
            çıkışToolStripMenuItem.Size = new Size(180, 22);
            çıkışToolStripMenuItem.Text = "Çıkış";
            // 
            // ürünToolStripMenuItem
            // 
            ürünToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { yeniToolStripMenuItem, msbProducts });
            ürünToolStripMenuItem.Name = "ürünToolStripMenuItem";
            ürünToolStripMenuItem.Size = new Size(45, 20);
            ürünToolStripMenuItem.Text = "Ürün";
            // 
            // yeniToolStripMenuItem
            // 
            yeniToolStripMenuItem.Name = "yeniToolStripMenuItem";
            yeniToolStripMenuItem.Size = new Size(180, 22);
            yeniToolStripMenuItem.Text = "Yeni";
            // 
            // msbProducts
            // 
            msbProducts.Name = "msbProducts";
            msbProducts.Size = new Size(180, 22);
            msbProducts.Text = "Listele";
            msbProducts.Click += msbProducts_Click;
            // 
            // siparişToolStripMenuItem
            // 
            siparişToolStripMenuItem.DropDownItems.AddRange(new ToolStripItem[] { yeniToolStripMenuItem1, siparişlerToolStripMenuItem, raporlarToolStripMenuItem });
            siparişToolStripMenuItem.Name = "siparişToolStripMenuItem";
            siparişToolStripMenuItem.Size = new Size(53, 20);
            siparişToolStripMenuItem.Text = "Sipariş";
            // 
            // yeniToolStripMenuItem1
            // 
            yeniToolStripMenuItem1.Name = "yeniToolStripMenuItem1";
            yeniToolStripMenuItem1.Size = new Size(180, 22);
            yeniToolStripMenuItem1.Text = "Yeni";
            // 
            // siparişlerToolStripMenuItem
            // 
            siparişlerToolStripMenuItem.Name = "siparişlerToolStripMenuItem";
            siparişlerToolStripMenuItem.Size = new Size(180, 22);
            siparişlerToolStripMenuItem.Text = "Siparişler";
            // 
            // raporlarToolStripMenuItem
            // 
            raporlarToolStripMenuItem.Name = "raporlarToolStripMenuItem";
            raporlarToolStripMenuItem.Size = new Size(180, 22);
            raporlarToolStripMenuItem.Text = "Raporlar";
            // 
            // FrmMain
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(574, 426);
            Controls.Add(menuStrip1);
            IsMdiContainer = true;
            MainMenuStrip = menuStrip1;
            Name = "FrmMain";
            StartPosition = FormStartPosition.CenterScreen;
            Text = "Northwind ERP";
            WindowState = FormWindowState.Maximized;
            menuStrip1.ResumeLayout(false);
            menuStrip1.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private MenuStrip menuStrip1;
        private ToolStripMenuItem uygulamaToolStripMenuItem;
        private ToolStripMenuItem hakkındaToolStripMenuItem;
        private ToolStripMenuItem çıkışToolStripMenuItem;
        private ToolStripMenuItem ürünToolStripMenuItem;
        private ToolStripMenuItem yeniToolStripMenuItem;
        private ToolStripMenuItem msbProducts;
        private ToolStripMenuItem siparişToolStripMenuItem;
        private ToolStripMenuItem yeniToolStripMenuItem1;
        private ToolStripMenuItem siparişlerToolStripMenuItem;
        private ToolStripMenuItem raporlarToolStripMenuItem;
    }
}
