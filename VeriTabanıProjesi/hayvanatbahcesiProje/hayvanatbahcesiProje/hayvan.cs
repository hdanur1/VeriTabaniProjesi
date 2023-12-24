using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;

namespace hayvanatbahcesiProje
{
    public partial class hayvan : Form
    {
        NpgsqlConnection conn;
        public hayvan(NpgsqlConnection connnection)
        {
            InitializeComponent();

            conn = connnection;
        }

        private void listele()
        {
            string sorgu = "select * from hayvan";

            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, conn);

            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }
        private void hayvan_Load(object sender, EventArgs e)
        {
            listele();
        }

        private void ekle_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("insert into hayvan (hayvanno, hayvanad, agirlik, bakicino, beslenmetipino, habitatno, turno) values (@p1, @p2, @p3, @p4, @p5, @p6, @p7)", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(hayvanno.Text));
            komut.Parameters.AddWithValue("@p2", hayvanad.Text);
            komut.Parameters.AddWithValue("@p3", int.Parse(agirlik.Text));
            komut.Parameters.AddWithValue("@p4", int.Parse(bakicino.Text));
            komut.Parameters.AddWithValue("@p5", int.Parse(beslenmetipino.Text));
            komut.Parameters.AddWithValue("@p6", int.Parse(habitatno.Text));
            komut.Parameters.AddWithValue("@p7", int.Parse(turno.Text));
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Ekleme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

            listele();
        }

        private void guncelle_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("update hayvan set hayvanad=@p2 where hayvanno=@p1", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(hayvanno.Text));
            komut.Parameters.AddWithValue("@p2", hayvanad.Text);
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Güncelleme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

            listele();
        }

        private void sil_Click(object sender, EventArgs e)
        {
            conn.Open();
            
            NpgsqlCommand komut = new NpgsqlCommand("delete from hayvan where hayvanno=@p1", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(hayvanno.Text));
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Silme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
            listele();

           
        }

        private void button1_Click(object sender, EventArgs e)
        {
            int tur = int.Parse(hayvanno.Text);
            string sorgu = "SELECT*from getirtur(" + tur + ")";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, conn);

            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0]; 
            

        }

        private void button2_Click(object sender, EventArgs e)
        {
            listele();
        }
    }
}
