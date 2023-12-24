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
    
    public partial class tur : Form
    {
        NpgsqlConnection conn;
        public tur(NpgsqlConnection connnection)
        {
            InitializeComponent();
            conn = connnection;
        }

        private void listele()
        {
            string sorgu = "select * from tur";

            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, conn);

            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }
        private void tur_Load(object sender, EventArgs e)
        {
            listele();
        }

        private void ekle_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("insert into tur (turno, turad) values (@p1, @p2)", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(turno.Text));
            komut.Parameters.AddWithValue("@p2", turad.Text);
            
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Ekleme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

            listele();
        }

        private void guncelle_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("update tur set turad=@p2 where turno=@p1", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(turno.Text));
            komut.Parameters.AddWithValue("@p2", turad.Text);
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Güncelleme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

            listele();
        }

        private void sil_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("delete from tur where turno=@p1", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(turno.Text));
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Silme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
            listele();
        }
    }
}
