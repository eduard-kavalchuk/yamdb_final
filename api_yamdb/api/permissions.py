from rest_framework import permissions


class IsAdmin(permissions.BasePermission):
    message = 'Check if the user who made the request is admin or superuser.'

    def has_permission(self, request, view):
        return request.user.is_authenticated and request.user.is_admin


class IsAdminOrReadOnly(permissions.BasePermission):
    message = ('Check if the user who made the request is admin or superuser,'
               'or ReadOnly.')

    def has_permission(self, request, view):
        return (request.method in permissions.SAFE_METHODS
                or (request.user.is_authenticated and request.user.is_admin))


class IsAdminModeratorAuthorOrReadOnly(permissions.BasePermission):
    message = ('Check if the user who made the request is admin'
               'or superuser, or Author, or ReadOnly.')

    def has_object_permission(self, request, view, obj):
        return (request.method in permissions.SAFE_METHODS
                or obj.author == request.user
                or request.user.is_moderator
                or request.user.is_admin)
