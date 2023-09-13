using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eKucniLjubimci.Services
{
    public static class rmqMail
    {
        public static void RabbitMQSend(string mailContent)
        {   
            rmqMailDetails mailDetalji = new rmqMailDetails
            {
                HostName = Environment.GetEnvironmentVariable("RabbitMQ_HostName")??"localhost",
                User = Environment.GetEnvironmentVariable("RabbitMQ_UserName") ?? "guest",
                Password = Environment.GetEnvironmentVariable("RabbitMQ_Password") ?? "guest",
                Port = int.Parse(Environment.GetEnvironmentVariable("RabbitMQ_Port") ?? "5672"),
                AdressFrom = Environment.GetEnvironmentVariable("RabbitMQ_MailAdressFrom") ?? "mittie14@ethereal.email",
                AdressTo = Environment.GetEnvironmentVariable("RabbitMQ_MailAdressTo") ?? "mittie14@ethereal.email",
                MailPassword = Environment.GetEnvironmentVariable("RabbitMQ_MailAdressPassword") ?? "yKK63A7b5r6KjrxNdP",
                SmtpMail = Environment.GetEnvironmentVariable("RabbitMQ_MailSMTP") ?? "smtp.ethereal.email",
                MailPort= int.Parse(Environment.GetEnvironmentVariable("RabbitMQ_MailPort") ?? "587"),
                EmailContent =mailContent                
            };

            var factory = new ConnectionFactory { 
                HostName = mailDetalji.HostName, 
                Port = mailDetalji.Port, 
                UserName = mailDetalji.User, 
                Password = mailDetalji.Password 
            };

            using var connection = factory.CreateConnection();
            using var channel = connection.CreateModel();

            channel.QueueDeclare(queue: "eKucniljubimciQueue",
                                 durable: false,
                                 exclusive: false,
                                 autoDelete: false,
                                 arguments: null);

            string json = JsonConvert.SerializeObject(mailDetalji);
            byte[]body=Encoding.UTF8.GetBytes(json);            

            channel.BasicPublish(exchange: string.Empty,
                                 routingKey: "eKucniljubimciQueue",
                                 basicProperties: null,
                                 body: body);  
        }
    }
}
