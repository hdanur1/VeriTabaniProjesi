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
    public partial class maasbilgisi : Form
    {

        NpgsqlConnection conn;
        public maasbilgisi(NpgsqlConnection connnection)
        {
            InitializeComponent();
            conn = connnection;
        }


        private void listele()
        {
            string sorgu = "select * from maasbilgisi";

            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, conn);

            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        } 

        private void maasbilgisi_Load(object sender, EventArgs e)
        {
            listele();
        }

        private void ekle_Click(object sender, EventArgs e)
        {
            
           int maasbilgisi = int.Parse(maasmiktari.Text);
           string sorgu = "SELECT maasbilgisiekle("+maasbilgisi+")";
           NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, conn);

           DataSet ds = new DataSet();
           da.Fill(ds);
           listele();
           
        }

        private void guncelle_Click(object sender, EventArgs e)
        {
            int maasbilgisi = int.Parse(maasmiktari.Text);
            int maasıd = int.Parse(maasno.Text);
            string sorgu = "SELECT maasbilgisiguncelle("+maasıd+"," + maasbilgisi + ")";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, conn);

            DataSet ds = new DataSet();
            da.Fill(ds);
            listele();
        }

        private void sil_Click(object sender, EventArgs e)
        {
            int maasbilgisi = int.Parse(maasno.Text);
            string sorgu = "SELECT maasbilgisisil(" + maasbilgisi + ")";
            NpgsqlDataAdapter da = new NpgsqlDataAdapter(sorgu, conn);

            DataSet ds = new DataSet();
            da.Fill(ds);
            listele();
        }

        
    }
}
