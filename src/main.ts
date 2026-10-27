import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { NestExpressApplication } from '@nestjs/platform-express';
import { ConfigService } from '@nestjs/config';
import Redis from 'ioredis';
//connect-redis v.7.1.1
import RedisStore from 'connect-redis';
import cookieParser from 'cookie-parser';
import { ValidationPipe } from '@nestjs/common';
import session from 'express-session';
import { ms, StringValue } from './libs/utils/ms.util';
import { parseBoolean } from './libs/utils/parse-boolean.util';

async function bootstrap() {
  //const app = await NestFactory.create(AppModule);

  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  // ОБЯЗАТЕЛЬНО ДЛЯ VERCEL / PROXIES
  // Без этого express-session не отправит куку, если secure: true
  app.set('trust proxy', 1);

  // УСТАНАВЛИВАЕМ ГЛОБАЛЬНЫЙ ПРЕФИКС ДЛЯ ВСЕХ КОНТРОЛЛЕРОВ БЭКЕНДА
  app.setGlobalPrefix('api');

  const config = app.get(ConfigService);

  const redis = new Redis(config.getOrThrow('REDIS_URL'));

  const isProduction = process.env.NODE_ENV === 'production';

  app.use(cookieParser(config.getOrThrow<string>('COOKIES_SECRET')));

  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
    }),
  );

  app.use(
    session({
      secret: config.getOrThrow<string>('SESSION_SECRET'),
      name: config.getOrThrow<string>('SESSION_NAME'),
      resave: true,
      saveUninitialized: false,
      proxy: true,
      cookie: {
        domain: isProduction
          ? '.info-media.by'
          : config.get<string>('SESSION_DOMAIN'),
        maxAge: ms(config.getOrThrow<StringValue>('SESSION_MAX_AGE')),
        httpOnly: parseBoolean(config.getOrThrow<string>('SESSION_HTTP_ONLY')),
        secure: parseBoolean(config.getOrThrow<string>('SESSION_SECURE')),
        sameSite: 'lax',
      },
      store: new RedisStore({
        client: redis,
        prefix: config.getOrThrow<string>('SESSION_FOLDER'),
        // ttl: ms(config.getOrThrow<StringValue>('SESSION_MAX_AGE')),
        // disableTouch: true,
      }),
    }),
  );

  app.enableCors({
    origin: [
      //'https://info-media.by',
      config.getOrThrow<string>('ALLOWED_ORIGIN'),
    ],
    credentials: true,
    //// exposedHeaders: ['set-cookie'],
  });

  await app.listen(config.getOrThrow<number>('APPLICATION_PORT'));
}
void bootstrap();
