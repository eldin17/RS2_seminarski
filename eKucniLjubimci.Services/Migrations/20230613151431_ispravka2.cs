using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eKucniLjubimci.Services.Migrations
{
    /// <inheritdoc />
    public partial class ispravka2 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "StateMachine",
                table: "Prodavci");

            migrationBuilder.DropColumn(
                name: "StateMachine",
                table: "Novosti");

            migrationBuilder.DropColumn(
                name: "StateMachine",
                table: "Kupci");

            migrationBuilder.AddColumn<bool>(
                name: "isDeleted",
                table: "Prodavci",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "isDeleted",
                table: "Novosti",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "isDeleted",
                table: "Kupci",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "isDeleted",
                table: "Prodavci");

            migrationBuilder.DropColumn(
                name: "isDeleted",
                table: "Novosti");

            migrationBuilder.DropColumn(
                name: "isDeleted",
                table: "Kupci");

            migrationBuilder.AddColumn<string>(
                name: "StateMachine",
                table: "Prodavci",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "StateMachine",
                table: "Novosti",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "StateMachine",
                table: "Kupci",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }
    }
}
