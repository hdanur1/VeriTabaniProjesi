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
    public partial class saglikci : Form
    {
        NpgsqlConnection conn;
        public saglikci(NpgsqlConnection connnection)
        {
            InitializeComponent();
            conn = connnection;
        }
        private void listele()
        {
            string sorgu = "select * from saglikci";

            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, conn);

            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }
        private void saglikci_Load(object sender, EventArgs e)
        {
            listele();
        }

        private void ekle_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("insert into saglikci (personelno, ad, soyad, personeltur, maasno) values (@p1, @p2, @p3, @p4, @p5)", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(personelno.Text));
            komut.Parameters.AddWithValue("@p2", ad.Text);
            komut.Parameters.AddWithValue("@p3", soyad.Text);
            komut.Parameters.AddWithValue("@p4", personeltur.Text);
            komut.Parameters.AddWithValue("@p5", int.Parse(maasno.Text));

            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Ekleme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

            listele();
        }

        private void guncelle_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("update saglikci set ad=@p2,soyad=@p3,personeltur=@p4,maasno=@p5 where personelno=@p1", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(personelno.Text));
            komut.Parameters.AddWithValue("@p2", ad.Text);
            komut.Parameters.AddWithValue("@p3", soyad.Text);
            komut.Parameters.AddWithValue("@p4", personeltur.Text);
            komut.Parameters.AddWithValue("@p5", int.Parse(maasno.Text));
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Güncelleme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

            listele();
        }

        private void sil_Click(object sender, EventArgs e)
        {
            conn.Open();

            NpgsqlCommand komut = new NpgsqlCommand("delete from saglikci where personelno=@p1", conn);
            komut.Parameters.AddWithValue("@p1", int.Parse(personelno.Text));
            komut.ExecuteNonQuery();
            conn.Close();
            MessageBox.Show("Silme başarıyla gerçekleşti.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
            listele();
        }
    }
}
