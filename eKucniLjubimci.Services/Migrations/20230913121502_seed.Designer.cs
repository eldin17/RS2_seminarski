﻿// <auto-generated />
using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;
using eKucniLjubimci.Services.Database;

#nullable disable

namespace eKucniLjubimci.Services.Migrations
{
    [DbContext(typeof(DataContext))]
    [Migration("20230913121502_seed")]
    partial class seed
    {
        /// <inheritdoc />
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("ProductVersion", "7.0.5")
                .HasAnnotation("Relational:MaxIdentifierLength", 128);

            SqlServerModelBuilderExtensions.UseIdentityColumns(modelBuilder);

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Artikal", b =>
                {
                    b.Property<int>("ArtikalId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ArtikalId"));

                    b.Property<decimal>("Cijena")
                        .HasColumnType("decimal(18,2)");

                    b.Property<bool>("Dostupnost")
                        .HasColumnType("bit");

                    b.Property<int>("KategorijaId")
                        .HasColumnType("int");

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Opis")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("StateMachine")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("ArtikalId");

                    b.HasIndex("KategorijaId");

                    b.ToTable("Artikli");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Kategorija", b =>
                {
                    b.Property<int>("KategorijaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("KategorijaId"));

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("isDeleted")
                        .HasColumnType("bit");

                    b.HasKey("KategorijaId");

                    b.ToTable("Kategorije");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.KorisnickiNalog", b =>
                {
                    b.Property<int>("KorisnickiNalogId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("KorisnickiNalogId"));

                    b.Property<DateTime>("DatumRegistracije")
                        .HasColumnType("datetime2");

                    b.Property<byte[]>("PasswordHash")
                        .IsRequired()
                        .HasColumnType("varbinary(max)");

                    b.Property<byte[]>("PasswordSalt")
                        .IsRequired()
                        .HasColumnType("varbinary(max)");

                    b.Property<int>("UlogaId")
                        .HasColumnType("int");

                    b.Property<string>("Username")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("isDeleted")
                        .HasColumnType("bit");

                    b.HasKey("KorisnickiNalogId");

                    b.HasIndex("UlogaId");

                    b.ToTable("KorisnickiNalozi");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Kupac", b =>
                {
                    b.Property<int>("KupacId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("KupacId"));

                    b.Property<int>("BrojNarudzbi")
                        .HasColumnType("int");

                    b.Property<bool>("Dvoriste")
                        .HasColumnType("bit");

                    b.Property<int>("KorisnickiNalogId")
                        .HasColumnType("int");

                    b.Property<bool>("Kuca")
                        .HasColumnType("bit");

                    b.Property<int>("LokacijaId")
                        .HasColumnType("int");

                    b.Property<int>("OsobaId")
                        .HasColumnType("int");

                    b.Property<string>("SlikaKupca")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("Stan")
                        .HasColumnType("bit");

                    b.Property<bool>("isDeleted")
                        .HasColumnType("bit");

                    b.HasKey("KupacId");

                    b.HasIndex("KorisnickiNalogId")
                        .IsUnique();

                    b.HasIndex("LokacijaId");

                    b.HasIndex("OsobaId")
                        .IsUnique();

                    b.ToTable("Kupci");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Lokacija", b =>
                {
                    b.Property<int>("LokacijaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("LokacijaId"));

                    b.Property<string>("Drzava")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Grad")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Ulica")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("isDeleted")
                        .HasColumnType("bit");

                    b.HasKey("LokacijaId");

                    b.ToTable("Lokacije");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Narudzba", b =>
                {
                    b.Property<int>("NarudzbaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("NarudzbaId"));

                    b.Property<DateTime>("DatumNarudzbe")
                        .HasColumnType("datetime2");

                    b.Property<int>("KupacId")
                        .HasColumnType("int");

                    b.Property<string>("PaymentId")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("PaymentIntent")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("StateMachine")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<decimal>("TotalFinal")
                        .HasColumnType("decimal(18,2)");

                    b.HasKey("NarudzbaId");

                    b.HasIndex("KupacId");

                    b.ToTable("Narudzbe");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.NarudzbaArtikal", b =>
                {
                    b.Property<int>("NarudzbaArtikalId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("NarudzbaArtikalId"));

                    b.Property<int>("ArtikalId")
                        .HasColumnType("int");

                    b.Property<int>("NarudzbaId")
                        .HasColumnType("int");

                    b.HasKey("NarudzbaArtikalId");

                    b.HasIndex("ArtikalId");

                    b.HasIndex("NarudzbaId");

                    b.ToTable("NarudzbeArtikli");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Novost", b =>
                {
                    b.Property<int>("NovostId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("NovostId"));

                    b.Property<DateTime>("DatumPostavljanja")
                        .HasColumnType("datetime2");

                    b.Property<string>("Naslov")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("ProdavacId")
                        .HasColumnType("int");

                    b.Property<string>("Sadrzaj")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("isDeleted")
                        .HasColumnType("bit");

                    b.HasKey("NovostId");

                    b.HasIndex("ProdavacId");

                    b.ToTable("Novosti");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Osoba", b =>
                {
                    b.Property<int>("OsobaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("OsobaId"));

                    b.Property<DateTime>("DatumRodjenja")
                        .HasColumnType("datetime2");

                    b.Property<string>("Ime")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Prezime")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("isDeleted")
                        .HasColumnType("bit");

                    b.HasKey("OsobaId");

                    b.ToTable("Osobe");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Prodavac", b =>
                {
                    b.Property<int>("ProdavacId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ProdavacId"));

                    b.Property<int>("KorisnickiNalogId")
                        .HasColumnType("int");

                    b.Property<int>("OsobaId")
                        .HasColumnType("int");

                    b.Property<string>("PoslovnaJedinica")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("SlikaProdavca")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("isDeleted")
                        .HasColumnType("bit");

                    b.HasKey("ProdavacId");

                    b.HasIndex("KorisnickiNalogId")
                        .IsUnique();

                    b.HasIndex("OsobaId")
                        .IsUnique();

                    b.ToTable("Prodavci");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Rasa", b =>
                {
                    b.Property<int>("RasaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("RasaId"));

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("isDeleted")
                        .HasColumnType("bit");

                    b.HasKey("RasaId");

                    b.ToTable("Rase");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Slika", b =>
                {
                    b.Property<int>("SlikaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("SlikaId"));

                    b.Property<int?>("ArtikalId")
                        .HasColumnType("int");

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Putanja")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("ZivotinjaId")
                        .HasColumnType("int");

                    b.Property<bool>("isDeleted")
                        .HasColumnType("bit");

                    b.HasKey("SlikaId");

                    b.HasIndex("ArtikalId");

                    b.HasIndex("ZivotinjaId");

                    b.ToTable("Slike");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Uloga", b =>
                {
                    b.Property<int>("UlogaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("UlogaId"));

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.HasKey("UlogaId");

                    b.ToTable("Uloge");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Vrsta", b =>
                {
                    b.Property<int>("VrstaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("VrstaId"));

                    b.Property<string>("Boja")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("Opis")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<bool>("Prostor")
                        .HasColumnType("bit");

                    b.Property<int>("RasaId")
                        .HasColumnType("int");

                    b.Property<int>("Starost")
                        .HasColumnType("int");

                    b.Property<bool>("isDeleted")
                        .HasColumnType("bit");

                    b.HasKey("VrstaId");

                    b.HasIndex("RasaId");

                    b.ToTable("Vrste");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Zivotinja", b =>
                {
                    b.Property<int>("ZivotinjaId")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("int");

                    SqlServerPropertyBuilderExtensions.UseIdentityColumn(b.Property<int>("ZivotinjaId"));

                    b.Property<decimal>("Cijena")
                        .HasColumnType("decimal(18,2)");

                    b.Property<DateTime>("DatumPostavljanja")
                        .HasColumnType("datetime2");

                    b.Property<bool>("Dostupnost")
                        .HasColumnType("bit");

                    b.Property<string>("Napomena")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int?>("NarudzbaId")
                        .HasColumnType("int");

                    b.Property<string>("Naziv")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<string>("StateMachine")
                        .IsRequired()
                        .HasColumnType("nvarchar(max)");

                    b.Property<int>("VrstaId")
                        .HasColumnType("int");

                    b.HasKey("ZivotinjaId");

                    b.HasIndex("NarudzbaId");

                    b.HasIndex("VrstaId");

                    b.ToTable("Zivotinje");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Artikal", b =>
                {
                    b.HasOne("eKucniLjubimci.Services.Database.Kategorija", "Kategorija")
                        .WithMany("Artikli")
                        .HasForeignKey("KategorijaId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Kategorija");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.KorisnickiNalog", b =>
                {
                    b.HasOne("eKucniLjubimci.Services.Database.Uloga", "Uloga")
                        .WithMany("KorisnickiNalozi")
                        .HasForeignKey("UlogaId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Uloga");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Kupac", b =>
                {
                    b.HasOne("eKucniLjubimci.Services.Database.KorisnickiNalog", "KorisnickiNalog")
                        .WithOne("Kupac")
                        .HasForeignKey("eKucniLjubimci.Services.Database.Kupac", "KorisnickiNalogId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("eKucniLjubimci.Services.Database.Lokacija", "Lokacija")
                        .WithMany("Kupci")
                        .HasForeignKey("LokacijaId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("eKucniLjubimci.Services.Database.Osoba", "Osoba")
                        .WithOne("Kupac")
                        .HasForeignKey("eKucniLjubimci.Services.Database.Kupac", "OsobaId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("KorisnickiNalog");

                    b.Navigation("Lokacija");

                    b.Navigation("Osoba");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Narudzba", b =>
                {
                    b.HasOne("eKucniLjubimci.Services.Database.Kupac", "Kupac")
                        .WithMany("Narudzbe")
                        .HasForeignKey("KupacId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Kupac");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.NarudzbaArtikal", b =>
                {
                    b.HasOne("eKucniLjubimci.Services.Database.Artikal", "Artikal")
                        .WithMany("NarudzbeArtikli")
                        .HasForeignKey("ArtikalId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("eKucniLjubimci.Services.Database.Narudzba", "Narudzba")
                        .WithMany("NarudzbeArtikli")
                        .HasForeignKey("NarudzbaId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Artikal");

                    b.Navigation("Narudzba");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Novost", b =>
                {
                    b.HasOne("eKucniLjubimci.Services.Database.Prodavac", "Prodavac")
                        .WithMany("Novosti")
                        .HasForeignKey("ProdavacId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Prodavac");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Prodavac", b =>
                {
                    b.HasOne("eKucniLjubimci.Services.Database.KorisnickiNalog", "KorisnickiNalog")
                        .WithOne("Prodavac")
                        .HasForeignKey("eKucniLjubimci.Services.Database.Prodavac", "KorisnickiNalogId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("eKucniLjubimci.Services.Database.Osoba", "Osoba")
                        .WithOne("Prodavac")
                        .HasForeignKey("eKucniLjubimci.Services.Database.Prodavac", "OsobaId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("KorisnickiNalog");

                    b.Navigation("Osoba");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Slika", b =>
                {
                    b.HasOne("eKucniLjubimci.Services.Database.Artikal", "Artikal")
                        .WithMany("Slike")
                        .HasForeignKey("ArtikalId");

                    b.HasOne("eKucniLjubimci.Services.Database.Zivotinja", "Zivotinja")
                        .WithMany("Slike")
                        .HasForeignKey("ZivotinjaId");

                    b.Navigation("Artikal");

                    b.Navigation("Zivotinja");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Vrsta", b =>
                {
                    b.HasOne("eKucniLjubimci.Services.Database.Rasa", "Rasa")
                        .WithMany("Vrste")
                        .HasForeignKey("RasaId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Rasa");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Zivotinja", b =>
                {
                    b.HasOne("eKucniLjubimci.Services.Database.Narudzba", "Narudzba")
                        .WithMany("Zivotinje")
                        .HasForeignKey("NarudzbaId");

                    b.HasOne("eKucniLjubimci.Services.Database.Vrsta", "Vrsta")
                        .WithMany("Zivotinje")
                        .HasForeignKey("VrstaId")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.Navigation("Narudzba");

                    b.Navigation("Vrsta");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Artikal", b =>
                {
                    b.Navigation("NarudzbeArtikli");

                    b.Navigation("Slike");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Kategorija", b =>
                {
                    b.Navigation("Artikli");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.KorisnickiNalog", b =>
                {
                    b.Navigation("Kupac");

                    b.Navigation("Prodavac");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Kupac", b =>
                {
                    b.Navigation("Narudzbe");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Lokacija", b =>
                {
                    b.Navigation("Kupci");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Narudzba", b =>
                {
                    b.Navigation("NarudzbeArtikli");

                    b.Navigation("Zivotinje");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Osoba", b =>
                {
                    b.Navigation("Kupac");

                    b.Navigation("Prodavac");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Prodavac", b =>
                {
                    b.Navigation("Novosti");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Rasa", b =>
                {
                    b.Navigation("Vrste");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Uloga", b =>
                {
                    b.Navigation("KorisnickiNalozi");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Vrsta", b =>
                {
                    b.Navigation("Zivotinje");
                });

            modelBuilder.Entity("eKucniLjubimci.Services.Database.Zivotinja", b =>
                {
                    b.Navigation("Slike");
                });
#pragma warning restore 612, 618
        }
    }
}
