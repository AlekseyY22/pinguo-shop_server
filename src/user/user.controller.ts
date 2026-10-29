import {
  Controller,
  HttpCode,
  HttpStatus,
  Get,
  Patch,
  Body,
  Param,
} from '@nestjs/common';
import { UserService } from './user.service';
import { Authorization } from '../auth/decorators/auth.decorator';
import { Authorized } from '../auth/decorators/authorized.decorator';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserRole } from '@prisma/client';
import { CurrentUser } from './decorators/user.decorator';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  //Получение профиля============================================
  @Authorization({ isOptional: true })
  @HttpCode(HttpStatus.OK)
  @Get('profile')
  public async getProfile(@Authorized('id') userId: string | null) {
    if (!userId) {
      return null;
    }
    return await this.userService.getById(userId);
  }

  //Обновление профиля============================================
  @Authorization()
  @HttpCode(HttpStatus.OK)
  @Patch('profile')
  public async updateProfile(
    @Authorized('id') userId: string,
    @Body() dto: UpdateUserDto,
  ) {
    return await this.userService.update(userId, dto);
  }

  //Получение пользователя по id==================================
  @Authorization(UserRole.ADMIN)
  @HttpCode(HttpStatus.OK)
  @Get('by-id/:id')
  public async getById(@Param('id') id: string) {
    return this.userService.getById(id);
  }

  //Добавление в избранное========================================
  @Authorization()
  @Patch('profile/favorites/:productId')
  public async toggleFavorite(
    @CurrentUser('id') userId: string,
    @Param('productId') productId: string,
  ) {
    return this.userService.toggleFavorite(productId, userId);
  }
}
