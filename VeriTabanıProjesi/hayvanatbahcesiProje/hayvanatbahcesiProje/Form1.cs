using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Npgsql;
using System.Windows.Forms;

namespace hayvanatbahcesiProje
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        NpgsqlConnection connection;
        private void baglan()
        {
            connection = new NpgsqlConnection("Host=localhost:5432;Username=postgres;Password=753951;Database=hayvanatbahcesi");
        }
        private void hayvan_Click(object sender, EventArgs e)
        {
            hayvan hayvan= new hayvan(connection); 

            hayvan.Show();
        }

        private void beslenme_Click(object sender, EventArgs e)
        {
            beslenme beslenme = new beslenme(connection);

            beslenme.Show();
        }

        private void habitat_Click(object sender, EventArgs e)
        {
            habitat habitat = new habitat(connection);

            habitat.Show();
        }

        private void tur_Click(object sender, EventArgs e)
        {
            tur tur = new tur(connection);

            tur.Show();
        }

        private void memeli_Click(object sender, EventArgs e)
        {
            memeli memeli = new memeli(connection);

            memeli.Show();
        }

        private void surungen_Click(object sender, EventArgs e)
        {
            surungen surungen = new surungen(connection);

            surungen.Show();
        }

        private void kus_Click(object sender, EventArgs e)
        {
            kus kus = new kus(connection);

            kus.Show();
        }

        private void ziyaretci_Click(object sender, EventArgs e)
        {
            ziyaretci ziyaretci = new ziyaretci(connection);

            ziyaretci.Show();
        }

        private void biletsatis_Click(object sender, EventArgs e)
        {
            biletsatis biletsatis = new biletsatis(connection);

            biletsatis.Show();
        }

        private void il_Click(object sender, EventArgs e)
        {
            il il = new il(connection);

            il.Show();
        }

        private void personel_Click(object sender, EventArgs e)
        {
            personel personel = new personel(connection);

            personel.Show();
        }

        private void saglikci_Click(object sender, EventArgs e)
        {
            saglikci saglikci = new saglikci(connection);

            saglikci.Show();
        }

        private void bakici_Click(object sender, EventArgs e)
        {
            bakici bakici = new bakici(connection);

            bakici.Show();
        }

        private void guvenlikgorevlisi_Click(object sender, EventArgs e)
        {
            guvenlikgorevlisi guvenlikgorevlisi = new guvenlikgorevlisi(connection);

            guvenlikgorevlisi.Show();
        }

        private void maasbilgisi_Click(object sender, EventArgs e)
        {
            maasbilgisi maasbilgisi = new maasbilgisi(connection);

            maasbilgisi.Show();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            // PostgreSQL veritabanı bağlantı dizesi
            baglan();
        }

      
    }
}
