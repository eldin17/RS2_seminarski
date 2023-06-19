using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eKucniLjubimci.Services.Migrations
{
    /// <inheritdoc />
    public partial class ispravke2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Slike_Artikli_ArtikalId",
                table: "Slike");

            migrationBuilder.DropForeignKey(
                name: "FK_Zivotinje_Narudzbe_NarudzbaId",
                table: "Zivotinje");

            migrationBuilder.AlterColumn<int>(
                name: "NarudzbaId",
                table: "Zivotinje",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AlterColumn<int>(
                name: "ArtikalId",
                table: "Slike",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<int>(
                name: "ZivotinjalId",
                table: "Slike",
                type: "int",
                nullable: true);

            migrationBuilder.AlterColumn<decimal>(
                name: "Total",
                table: "Artikli",
                type: "decimal(18,2)",
                nullable: true,
                oldClrType: typeof(decimal),
                oldType: "decimal(18,2)");

            migrationBuilder.AlterColumn<int>(
                name: "Kolicina",
                table: "Artikli",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_Slike_Artikli_ArtikalId",
                table: "Slike",
                column: "ArtikalId",
                principalTable: "Artikli",
                principalColumn: "ArtikalId");

            migrationBuilder.AddForeignKey(
                name: "FK_Zivotinje_Narudzbe_NarudzbaId",
                table: "Zivotinje",
                column: "NarudzbaId",
                principalTable: "Narudzbe",
                principalColumn: "NarudzbaId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Slike_Artikli_ArtikalId",
                table: "Slike");

            migrationBuilder.DropForeignKey(
                name: "FK_Zivotinje_Narudzbe_NarudzbaId",
                table: "Zivotinje");

            migrationBuilder.DropColumn(
                name: "ZivotinjalId",
                table: "Slike");

            migrationBuilder.AlterColumn<int>(
                name: "NarudzbaId",
                table: "Zivotinje",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "ArtikalId",
                table: "Slike",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AlterColumn<decimal>(
                name: "Total",
                table: "Artikli",
                type: "decimal(18,2)",
                nullable: false,
                defaultValue: 0m,
                oldClrType: typeof(decimal),
                oldType: "decimal(18,2)",
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "Kolicina",
                table: "Artikli",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Slike_Artikli_ArtikalId",
                table: "Slike",
                column: "ArtikalId",
                principalTable: "Artikli",
                principalColumn: "ArtikalId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Zivotinje_Narudzbe_NarudzbaId",
                table: "Zivotinje",
                column: "NarudzbaId",
                principalTable: "Narudzbe",
                principalColumn: "NarudzbaId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
