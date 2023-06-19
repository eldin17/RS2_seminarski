using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services.Database
{
    public class DataContext : DbContext
    {
        public DataContext()
        {
        }
        public DataContext(DbContextOptions options):base(options)
        {
        }

        public virtual DbSet<Artikal> Artikli { get; set; }
        public virtual DbSet<Kategorija> Kategorije { get; set; }
        public virtual DbSet<KorisnickiNalog> KorisnickiNalozi { get; set; }
        public virtual DbSet<Kupac> Kupci { get; set; }
        public virtual DbSet<Lokacija> Lokacije { get; set; }
        public virtual DbSet<Narudzba> Narudzbe { get; set; }
        public virtual DbSet<NarudzbaArtikal> NarudzbeArtikli { get; set; }
        public virtual DbSet<Novost> Novosti { get; set; }
        public virtual DbSet<Osoba> Osobe { get; set; }
        public virtual DbSet<Prodavac> Prodavci { get; set; }
        public virtual DbSet<Slika> Slike { get; set; }
        public virtual DbSet<Uloga> Uloge { get; set; }
        public virtual DbSet<Vrsta> Vrste { get; set; }
        public virtual DbSet<Zivotinja> Zivotinje { get; set; }

    }
}
