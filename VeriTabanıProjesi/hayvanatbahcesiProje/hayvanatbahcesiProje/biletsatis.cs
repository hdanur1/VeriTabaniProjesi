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
    public partial class biletsatis : Form
    {
        NpgsqlConnection conn;
        public biletsatis(NpgsqlConnection connnection)
        {
            InitializeComponent();
            conn = connnection;
        }

        private void listele()
        {
            string sorgu = "select * from biletsatis";

            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, conn);

            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void biletsatis_Load(object sender, EventArgs e)
        {
            listele();
        }

        private void ekle_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("insert into biletsatis (biletno, biletfiyat) values (@p1, @p2)", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(biletno.Text));
            komut.Parameters.AddWithValue("@p2", int.Parse(biletfiyat.Text));

            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Ekleme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

            listele();
        }

        private void guncelle_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("update biletsatis set biletfiyat=@p2 where biletno=@p1", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(biletno.Text));
            komut.Parameters.AddWithValue("@p2", int.Parse(biletfiyat.Text));
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Güncelleme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

            listele();
        }

        private void sil_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("delete from biletsatis where biletno=@p1", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(biletno.Text));
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Silme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
            listele();
        }
    }
}
