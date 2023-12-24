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
    public partial class beslenme : Form
    {

        NpgsqlConnection conn;
        public beslenme(NpgsqlConnection connnection)
        {
            InitializeComponent();
            conn = connnection;
        }

        private void listele()
        {
            string sorgu = "select * from beslenme_bilgisi";

            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, conn);

            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void beslenme_Load(object sender, EventArgs e)
        {
            listele();
        }
        private void ekle_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("insert into beslenme_bilgisi (beslenmeno, beslenme_tipi) values (@p1, @p2)", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(beslenmeno.Text));
            komut.Parameters.AddWithValue("@p2", beslenmetipi.Text);
           
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Ekleme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

            listele();
        }

        private void guncelle_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("update beslenme_bilgisi set beslenme_tipi=@p2 where beslenmeno=@p1", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(beslenmeno.Text));
            komut.Parameters.AddWithValue("@p2", beslenmetipi.Text);
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Güncelleme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

            listele();
        }

        private void sil_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("delete from beslenme_bilgisi where beslenmeno=@p1", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(beslenmeno.Text));
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Silme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
            listele();
        }
    }
}
