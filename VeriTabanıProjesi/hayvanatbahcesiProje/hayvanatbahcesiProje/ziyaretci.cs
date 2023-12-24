using Npgsql;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace hayvanatbahcesiProje
{
    public partial class ziyaretci : Form
    {
        NpgsqlConnection conn;
        public ziyaretci(NpgsqlConnection connnection)
        {
            InitializeComponent();
            conn = connnection;
        }
        private void listele()
        {
            string sorgu = "select * from ziyaretci";

            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, conn);

            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }
        private void ziyaretci_Load(object sender, EventArgs e)
        {
            listele();
        }

        private void ekle_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("insert into ziyaretci (ziyaretcino, ad, soyad, yas, bilet, il) values (@p1, @p2, @p3, @p4, @p5, @p6)", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(ziyaretcino.Text));
            komut.Parameters.AddWithValue("@p2", ad.Text);
            komut.Parameters.AddWithValue("@p3", soyad.Text);
            komut.Parameters.AddWithValue("@p4", int.Parse(yas .Text));
            komut.Parameters.AddWithValue("@p5", int.Parse(bilet.Text));
            komut.Parameters.AddWithValue("@p6", int.Parse(il.Text));
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Ekleme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

            listele();
        }

        private void guncelle_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("update ziyaretci set ad=@p2,soyad=@p3,yas=@p4,bilet=@p5,il=@p6 where ziyaretcino=@p1", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(ziyaretcino.Text));
            komut.Parameters.AddWithValue("@p2", ad.Text);
            komut.Parameters.AddWithValue("@p3", soyad.Text);
            komut.Parameters.AddWithValue("@p4", int.Parse(yas.Text));
            komut.Parameters.AddWithValue("@p5", int.Parse(bilet.Text));
            komut.Parameters.AddWithValue("@p6", int.Parse(il.Text));
           
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Güncelleme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

            listele();
        }

        private void sil_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("delete from ziyaretci where ziyaretcino=@p1", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(ziyaretcino.Text));
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Silme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
            listele();
        }
    }
}
